Return-Path: <linux-kernel-owner+w=401wt.eu-S1767628AbXCIXNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767628AbXCIXNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767629AbXCIXNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:13:42 -0500
Received: from main.gmane.org ([80.91.229.2]:47501 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767632AbXCIXNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:13:41 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: [PATCH/RFC] Delete JFFS (version 1)
Date: Fri, 09 Mar 2007 18:13:19 -0500
Message-ID: <jwv8xe6rp1g.fsf-monnier+gmane.linux.file-systems.jffs@gnu.org>
References: <457EA2FE.3050206@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: bas1-montreal02-1096717076.dsl.bell.ca
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
Cancel-Lock: sha1:3Y9dDQusby28yVDnkgx34kBsulw=
Cc: linux-fsdevel@vger.kernel.org, jffs-dev@axis.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I argue that you can count the users (who aren't on 2.4) on one hand, and
> developers don't seem to have cared for it in ages.

Rather than ask on mailing-lists, it's probably easier to just make the jffs
compilation fail (with a #error).  This way, if someone uses it, he'll bump
into it, no matter how much he wants to ignore messages posted on
mailing-lists.


        Stefan

