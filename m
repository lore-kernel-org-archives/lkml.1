Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYLTKuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYLTKuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 05:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYLTKuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 05:50:24 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:4276 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYLTKuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 05:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:content-disposition:from:date:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=UBXoKaHVRhI+xy8iTxjksS+gxd1ecXEvFAvL47rT5Zhh0c6eHXgmCYhAj28H8b4dH7
         tGqamUtFWbif0EdXaYvyDnU28E8Emq9MpNoeZaLyQGT53qjfjkfh+eZwLfGMc2Zanls4
         wveRKgTYrhZctJY2j31M19B2zA0vC4cCO75yg=
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: [PATCH] Input: i8042 - add Gigabyte M912 netbook to noloop exception table
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sat, 20 Dec 2008 02:50:02 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200812200250.02320.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ozan,

On Monday 15 December 2008 06:02:19 Ozan Çağlayan wrote:
> From: Ozan Çağlayan <ozan@pardus.org.tr>
> Date:   Mon Dec 15 13:53:08 2008 +0200
>
>     Input: i8042 - add Gigabyte M912 netbook to noloop exception table
>
>     Gigabyte M912's touchpad needs i8042.noloop for working.
>

Thank you for your patch, applied to the 'next' branch of my tree.

BTW, your mailer seems to convert tabs into spaces which messes up patches.

-- 
Dmitry

