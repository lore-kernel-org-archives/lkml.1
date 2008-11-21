Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYKUKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYKUKK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYKUKKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:10:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:14530 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYKUKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wje+CyLH7zJMIJUNbiticESrN3h+Qc99Im1VwCQVIUPr/Q1jzoQVK3FcenR6QccAzk
         ArvCkbYq87FfdnjTClpIcmUJnuhwqkmtg4jOe5F8BRSUROl9tAh2LeUnkDpGkaKDyq5a
         Z07L9lRCzXAn7dLLr9aXeSnTJ0aD71BZ3QmwU=
Message-ID: <df9815e70811210210v5380c7c8h2f70a4f6248ce57c@mail.gmail.com>
Date: Fri, 21 Nov 2008 18:10:17 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Tarkan Erimer" <tarkan.erimer@turknet.net.tr>
Subject: Re: Btrfs with Linux-2.6.28-rc6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49267FF3.3010608@turknet.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49267FF3.3010608@turknet.net.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 5:31 PM, Tarkan Erimer
<tarkan.erimer@turknet.net.tr> wrote:
> Hi folks,
>
> How can I use the btrfs-unstable with the recently released Linux-2.6.28-rc6
> ? Yesterday, Chris sent an email that he updated the btrfs-unstable git tree
> to use with Linux-2.6.28-rc5. But, applying the patch-2.6.28-rc6 against
> Chris' tree fails because of being already patched before. So, What to do ?
>

I think Chris forgot to push his tree out.  The `git describe' still
shows a "v2.6.27-rc7-9932-gea6a478".

-- 
Thanks,
Jike
