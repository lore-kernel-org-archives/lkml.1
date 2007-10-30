Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXJ3KQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXJ3KQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXJ3KQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:16:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5700 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXJ3KQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dLrrRBUQmwoqeneWmUlK5ZAP73T1pzX7OPa5UcKjZjeaBbD99mEFIN+yvoR2hmaQTmvdN2wjV2Z1v61WKXOrIPOXThcDb999Z3Y+tZBBZlLqaZi0qlS2CsZC2zPV0fZ3lsJz+LtAXUrVSe8kQ3z/AiN+EFFZtwFWiXebi3J/RUU=
Message-ID: <3d8471ca0710300315l62ae1845o782be670e9181f61@mail.gmail.com>
Date: Tue, 30 Oct 2007 11:15:59 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] scheduler fix
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071029233417.GA14143@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029203923.GA9314@elte.hu> <20071029233417.GA14143@elte.hu>
X-Google-Sender-Auth: cb7e22f0e6f50d84
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/30, Ingo Molnar <mingo@elte.hu>:
>  fs/proc/array.c       |    3 ++-
>  include/linux/sched.h |    2 +-
>  kernel/fork.c         |    1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)

Hello Ingo,

do you think it would be possible to include the patch in your git
pull request emails? Especially when the patch is small like this one.

Jeff showed a suitable script in
http://www.uwsg.iu.edu/hypermail/linux/kernel/0710.1/2218.html

Thanks.

-- 
Guillaume
