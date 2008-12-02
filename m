Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYLBIA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYLBIA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 03:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYLBIAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 03:00:17 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:62906 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYLBIAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 03:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TO4XcfOzVS9XU09aEvKGpXnwD4dOmt0Atqh/84Lrx7j7vsSyoNFZdTN0IdxkEXq9lI
         1AB87rtzExlnZ81GAQ20+7JzaGKLC2mLyuEwVZ6gURSjGO15l2xzxkoVBudX72ake8Dz
         RFTykEDe3l7GJLqkYpSsFEYp4IT3YsTdpOTd8=
Message-ID: <5d5443650812020000t3ed04d1am4963b9fe914d34a0@mail.gmail.com>
Date: Tue, 2 Dec 2008 13:30:13 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       v4l <video4linux-list@redhat.com>,
       "Sakari Ailus" <sakari.ailus@nokia.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <5d5443650812012228u5aad36a2jc3e9e68cd61c27e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812011451.06156.hverkuil@xs4all.nl>
	 <5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
	 <20081201202209.5cea1f4b@pedra.chehab.org>
	 <5d5443650812012228u5aad36a2jc3e9e68cd61c27e3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 2, 2008 at 11:58 AM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Mauro,
>
>>
>> This is one of the lack of the features on mercurial. It doesn't have a meta
>> tag for committer. On mercurial, the -hg user and the author should be the same
>> person.
>>
>> Since we want to identify the patch origin (e.g. whose v4l/dvb maintainer got
>> the patch), we use the internal "user" meta-tag as the committer, and an extra
>> tag, at the patch description for the author (From:).
>>
>> When creating the -git patch, the "From:" tag is replaced, by script, for
>> "Author:", I add my SOB there, and, I add myself as the -git committer (on git
>> we have both meta-tags).
>
> Isn't it good time to move v4l2-dvb tree to GIT? I am not aware of any
> hg-to-git repo. converter, but I can check with hg and git community.
> It could be difficult at first, but I am very confident that there are
> many GIT users here than mercurial, and yes your v4l-dvb maintenance
> process might change due move from GIT, but atleast you will not have
> to internal user meta-data per patch.

OK, there are tools to convert mercurial to git repo.

http://git.or.cz/gitwiki/InterfacesFrontendsAndTools#head-8870e1c81cc93f9a7a7acb5e969924ee60182d6b
http://hedonismbot.wordpress.com/2008/10/16/hg-fast-export-convert-mercurial-repositories-to-git-repositories/


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
