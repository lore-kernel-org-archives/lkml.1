Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYISGJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYISGJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 02:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYISGJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 02:09:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:64575 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYISGJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 02:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eJrPdVkJR7hxvyySE8VrTG+2o+0uJUoyC1bwN8TUGlGCuG+Ye3BLMXRgKMoymUVlKj
         CEc0vzlkxoQsEyJQi0xd8Cl8QphUGKf04eoohc2sXIfRY1cfmfyVu/B+kw94bADHNdHE
         W+GHVJpyAVMHh8CbQTeRDWkoWiSgDNSBZCUYI=
Message-ID: <30b945310809182309t4514e814r4707a1deeb52dc5a@mail.gmail.com>
Date: Fri, 19 Sep 2008 01:09:30 -0500
From: "John Livingston" <jlivings@gmail.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata flooding syslog
In-Reply-To: <30b945310809182307g67d94673meeefc8e201f9b72c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915100909.79c1d67b@werewolf.home>
	 <20080919001834.31a3f8f9@werewolf.home>
	 <30b945310809182307g67d94673meeefc8e201f9b72c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick search turned up
http://marc.info/?l=linux-kernel&m=121868782917600  The patch in that
thread might be worth a shot.  I'd definitely try a mainline kernel
first though.

--
John Livingston
jlivings@gmail.com
