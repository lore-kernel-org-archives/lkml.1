Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYDYEGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYDYEGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYDYEGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:06:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38185 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYDYEGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:06:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GsM9Y4j4YbmNepP8y8cMeYArAMoBrzEdW6gcFuk6FqM8GpAp8ECvauLFbHrhvbTYI+E/rlQ38oO2pHzO+VoAXp+APG6oIznAHbbr3Aaq7uu74lFJTLP0PehS6gY7Mljbaw33qrLxVG4kWBO4B33hvoMdMX1NNfqTjQ6horSP9Yw=
Message-ID: <386072610804242106r123e6334id39a18002915464e@mail.gmail.com>
Date: Fri, 25 Apr 2008 12:06:13 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [INPUT/KEYBOARD] Blackfin BF54x: Add infrastructure for keypad wakeups
Cc: "Michael Hennerich" <michael.hennerich@analog.com>,
       "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <1209095728-21119-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209095728-21119-1-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: c9ebbd060541b1dc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 11:55 AM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
>  Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>  Signed-off-by: Bryan Wu <cooloney@kernel.org>
>  ---
>   drivers/input/keyboard/bf54x-keys.c |   36 ++++++++++++++++++++++++++++++++--
>   1 files changed, 33 insertions(+), 3 deletions(-)
>

Hi Dmitry,

Sorry for resending this patch, I forget it was accept by you.
Please ignore this.

Thanks
-Bryan
