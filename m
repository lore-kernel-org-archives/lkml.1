Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbYB2O4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbYB2O4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYB2Oz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:55:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:27527 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYB2Ozz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=CrGgA2exoIQKF+p00aAj1RkqFKbThApWHtqIB6kraiFgbztcFJbGIWIEDTamYChMfcHm1woHjZ/VePDyOfK6qmMuizY7JpGAAVxJD1JRnCWbg1lS4HOqqQpbaBIbW4Z+WhWHC0AgGk6TAhmc9T6AVfgXGuE+Pg/2GjLfgIyc0Yc=
Date: Fri, 29 Feb 2008 15:54:08 +0100
From: Diego Calleja <diegocg@gmail.com>
To: "Stephen Cuppett" <cuppett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance versus FreeBSD 7.0
Message-Id: <20080229155408.116fa5a1.diegocg@gmail.com>
In-Reply-To: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 29 Feb 2008 08:38:00 -0500, "Stephen Cuppett" <cuppett@gmail.com> escribió:

> loads and 1500% at high loads. When compared with the best performing
> Linux kernel (2.6.22 or 2.6.24) performance is 15% better. Results are

There has been some performance problems with sysbench performance in linux
which made it slower than freebsd, there were some patches to speed things up,
not sure if they have been merged.

Myself I find fun that they look at Linux as the Leader That Must Be Surpassed.
All the performance highlights of freebsd 7.0 are things that linux already did some
years ago.
