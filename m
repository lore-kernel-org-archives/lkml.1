Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZGMQUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZGMQUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbZGMQUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:20:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:17190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZGMQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rLFk+ZpWWhL1Bv7u7SnNje+Hr28RhoFdAVU/nhn0iAm+/KcihehWEnWDCy58b8MpM5
         1rrgtEXJfz0aBfbio42QxMKt9N0i3ScGLBdDzGw9JrK4RkokrLRNxTXBgMVJl+0XpcXp
         tPOYSR2hgW4Y4aypaaDk+NJfUO0bqjaJdAy0A=
MIME-Version: 1.0
In-Reply-To: <1247238435-19330-1-git-send-email-srcvale@holoscopio.com>
References: <1247238435-19330-1-git-send-email-srcvale@holoscopio.com>
Date: Mon, 13 Jul 2009 18:19:57 +0200
Message-ID: <cd73a99e0907130919t6c7f7690wd33f591a546164a8@mail.gmail.com>
Subject: Re: [PATCH] trivial: fix typos in comments s/DGBU/DBGU/
From: Andrew Victor <avictor.za@gmail.com>
To: "Samuel R. C. Vale" <srcvale@holoscopio.com>
Cc: Andrew Victor <linux@maxim.org.za>, trivial@kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Samuel,

> DBGU means Debug Unit, was refered as "DGBU" in some files. Fixed to "DBGU".
>
> Signed-off-by: Samuel R. C. Vale <srcvale@holoscopio.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
