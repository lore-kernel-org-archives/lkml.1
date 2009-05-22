Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZEVPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZEVPMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZEVPMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:12:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:60989 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbZEVPMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dbOQQ6+tp8XzONncJi6yLNP5BlRvxviU9op/DorCSCNqVd3Ru5jxrTcPooLSfL/6UP
         J9SfHGDb84uCtw1mAneY9VMF1PVN7dQgE/uuRKQKPOy5M2Eqg7ASts2O0ydMfORrSGCo
         m6KLUr6oNh1IWqFJgRM/iIp9G1k9vIISqh4QU=
MIME-Version: 1.0
In-Reply-To: <1242918732-4988-1-git-send-email-tom.leiming@gmail.com>
References: <1242918732-4988-1-git-send-email-tom.leiming@gmail.com>
Date: Fri, 22 May 2009 23:12:07 +0800
Message-ID: <d82e647a0905220812q19aff43fw23cb9dc0ce1b5a76@mail.gmail.com>
Subject: Re: [PATCH] kernel:lockdep:print the shortest dependency chain if 
	finding a circle
From: Ming Lei <tom.leiming@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any objections or suggestions?

Thanks.


-- 
Lei Ming
