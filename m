Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbYHFEGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbYHFEGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYHFEGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:06:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:51920 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYHFEGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FuhLw/Nqh9HOzgbukJmyDrgEYFX2YtjOfZzCocIc4UUBUKPlBDb4T6jM0kiKPQeQNj
         vCsMW9kOODPUJma6SKxxghWRyxELe6tPhNPBqwNFkBST1cHfRbo0cnfX31IJp7/7y6a8
         Yx4mMnVFuS957M3J3Uhjuf6nsrcVV8080noYQ=
Message-ID: <b6a2187b0808052106l1c553df4lab4e9e9f29de356d@mail.gmail.com>
Date: Wed, 6 Aug 2008 12:06:29 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48992085.3050203@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <48991B07.3050500@qualcomm.com>
	 <b6a2187b0808052050h35e2786fwfbf1e1dd5c37d8cf@mail.gmail.com>
	 <48992085.3050203@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 11:54 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:

> Are you running 32-bit kernel ?

Yes. But, does it matter?

Thanks,
Jeff.
