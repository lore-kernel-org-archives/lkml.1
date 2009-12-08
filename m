Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZLHHnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZLHHnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZLHHnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:43:08 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:46974 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZLHHnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uINiiJwVOUkeJU++7XZr6QyleakYar//+6bZYEblZ7Zn0CzcubGjcklDbgNXMDN40J
         CLYCzn3QJPzbPMH3MArAGivVjqniLU4aiggQIFObt5PsYHcQKnVlljcJ0ul61HfbqyG0
         3XHd2bfbN/+4xzICzgHWWnJLo3iBjJzgzw8Iw=
MIME-Version: 1.0
In-Reply-To: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>
References: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>
Date: Tue, 8 Dec 2009 08:43:13 +0100
Message-ID: <71cd59b00912072343g2fe258b6sc495337cdccd169e@mail.gmail.com>
Subject: Re: [Resend] [PATCH] asus-laptop: add Lenovo SL LenovoCare LED 
	support
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 8:37 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> Resend because the email address of signed-off is wrong in prior mail
>
> This patch is to enable the LenovoCare LED support on Lenovo SL laptop. Based
> on the found of the control interface by Alexandre Rostovtsev
>
> Turn on the LenovoCare LED:
>  (As root privileges) echo 1 > /sys/class/leds/asus\:\:LenovoCare/brightness
> Trun off the LenovoCare LED:
>  (As root privileges) echo 0 > /sys/class/leds/asus\:\:LenovoCare/brightness
>
> The patch against current checkout of acpi4asus is below.
>
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>

Hi,
Is there another method to control that led in _SB.ATKD ?
Could you re-send me some Leveno dsdt (if possible, more than one) ?
Thanks,


-- 
Corentin Chary
http://xf.iksaif.net
