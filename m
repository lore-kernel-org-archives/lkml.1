Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbYASTl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbYASTl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYASTlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:41:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:19964 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYASTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RQdtiFs5h5V9iM0JX3TuuXx3Heoce4WcSrMmQdCN4UhMPd78AYN4xGbnhYysu3iuBgHBRSSGASFO8sEjiulej2kICSxJF8IcX0Vn5ZYQcAvSdfvXxs3v/hnG0WKlUu/ghfEI8EAr9bhB3ks/wTMcPLrFm+IanPjlsGDnK+wBocs=
Message-ID: <38b2ab8a0801191141g31137fe5m3b5fff35499588e5@mail.gmail.com>
Date: Sat, 19 Jan 2008 20:41:18 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Why not creating a GIT RT tree ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0801181400110.10928@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
	 <Pine.LNX.4.58.0801180947180.7574@gandalf.stny.rr.com>
	 <38b2ab8a0801180937y4264fc15wd3b91ca74635f679@mail.gmail.com>
	 <Pine.LNX.4.58.0801181400110.10928@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 8:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> True, but then how would you do it. One thing is that most of these
> branches would interact with each other. Touching the same code quite
> a bit. So it doesn't always help. But pulling out patches can help us to
> an extent.
>

I see, it would probably be too painful in this context, that's pity.

>
> Great! Looking forward to it ;-)
>

Well actually it seems already supported. Some files in arch/sh
are already touched by RT patches.

I took a look to your interesting paper and I have now a question
about the BKL: Why is it so hard to get ride of it completely ?

Do you have any advices or starting point to get involved in RT kernel ?
I'm almost new in this area but I'd like to acquire some knowledges and
try to contribute if possible...

Thanks !
-- 
Francis
