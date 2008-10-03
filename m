Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYJCB1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYJCB1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 21:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYJCB12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 21:27:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:22543 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYJCB11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 21:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BC/o/Llhmg67wWpf+H2PnLVFRow4pgOACvrfZsJrbfSPCSrQEtVKtrrHNTG9RzxJum
         L2r5so0BK4BiKO/1bf2noBUF23imGbupz9Wh4zrKfIs9Y45o9hh+L9/yazi+9TzK6CxP
         /55ArhzTQPxY/24GrvgPcd4/7XKcL9t8EEG6w=
Message-ID: <86802c440810021827j24b45ffexefd1a4f5034771e5@mail.gmail.com>
Date: Thu, 2 Oct 2008 18:27:26 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "D. Hugh Redelmeier" <hugh@mimosa.com>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0810021954330.4688@redclaw.mimosa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	 <20081003000314.771b2f68@werewolf.home>
	 <86802c440810021533v572975e8n40e55009cc2b2d8a@mail.gmail.com>
	 <alpine.LRH.2.00.0810021954330.4688@redclaw.mimosa.com>
X-Google-Sender-Auth: c90edf408855332c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 4:55 PM, D. Hugh Redelmeier <hugh@mimosa.com> wrote:
> | From: Yinghai Lu <yinghai@kernel.org>
>
> | can you boot with mtrr_cleanup_debug?
> |
> | also what is /proc/mtrr with disable_mtrr_cleanup?
>
> Shouldn't mtrr_cleanup_debug show the pre-cleanup MTRR settings?

yeah, will add some line about that.

YH
