Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZHYKVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZHYKVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZHYKVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:21:33 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64514 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZHYKVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=PTTrF+rmJcjvJFEl/woXPR28Wqy0XJxlBxld0wR2R5PFpWtoaSiCKLT+SCXx1zSrXe
         rL8FHu8xRXw+jJQvV9fNSn+zmlqpTFy3z0jAxbRAJGRAYNtkvyagdC+s7JjBGjZC2Omr
         h8h5TUv4+mWdh99rUAAmfsPQH4HmBN2PCXZ44=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Xiangfu Liu <xiangfu.z@gmail.com>
Subject: Re: what is the meaning of matrix_keypad_platform_data.active_low
Date: Tue, 25 Aug 2009 12:21:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-1-amd64; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <4A93903F.3080005@gmail.com>
In-Reply-To: <4A93903F.3080005@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908251221.10797.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 25. srpna 2009 09:18:23 Xiangfu Liu napsal(a):
> Hi
> ./include/linux/input/matrix_keypad.h
> there no help in matrix_keypad.h about active_low.
>
> I guess. when set active_low to 1.means:
>
> 0: key press
> 1: key not press
>
> right?

Hi, yeah, it means the GPIO pins have inverted voltage levels.
>
> thanks for help.
