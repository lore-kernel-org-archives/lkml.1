Return-Path: <linux-kernel-owner+w=401wt.eu-S1766936AbXEBULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766936AbXEBULb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766939AbXEBULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:11:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:44434 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766936AbXEBUL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JkDpyrKafHFgDLWEGQeEZqwio460+OwHAPn/vRZYd15SJBtp5pa/EmL1hJjNav8FQ8ayBHVS9I9I9L8MFRqQMXyaZMeb+1vKUC814BRRobCfH0nJEMSOsEkQ0RJnVD/6T2m3Fo/VH1Yp8xc+kSpDXOwkbqdFELmCJH7ch7eKvew=
Date: Wed, 2 May 2007 22:10:45 +0200
From: Diego Calleja <diegocg@gmail.com>
To: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FEATURE REQUEST: merge MD software raid and LVM in one unique
 layer.
Message-Id: <20070502221045.ad20b915.diegocg@gmail.com>
In-Reply-To: <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>
	<f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 2 May 2007 20:18:55 +0100, "Miguel Sousa Filipe" <miguel.filipe@gmail.com> escribió:

> I find it high irritanting having two kernel interfaces and two
> userland tools that provide the same funcionality, which one should I
> use?

I doubt users care about kernel's design; however the lack of unification of
userspace tools is a real problem. Just my 2¢.
