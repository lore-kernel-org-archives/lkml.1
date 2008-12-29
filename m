Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYL2MWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYL2MWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYL2MWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:22:32 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:37177 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYL2MWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uTfGdg9SHyn5BAHyYL0+EGHeFbgHeSotnmeuE5xXzr+IE7xwhCkU2DNrxbLAzfotF+
         avcK4QVKuAgOIDr6sE7osWdsOlGWiiV6ZaEby7xavEV6kk5cbYIfawpa0IkR/315p4FG
         VanUy486tFhosJ8TFos3pcNgvnC1XX/7FyqfU=
Message-ID: <8bd0f97a0812290422v6d8a7228i78fdee7b6666f5a4@mail.gmail.com>
Date: Mon, 29 Dec 2008 07:22:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/timex.h: cleanup for userspace
In-Reply-To: <1230360578-6605-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230360578-6605-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:49, Mike Frysinger wrote:
> Move all the kernel-specific defines and includes into the __KERNEL__
> section so that they don't get leaked into userspace.

erp, looks like Ingo already posted this for inclusion in 2.6.29
-mike
