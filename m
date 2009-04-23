Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZDWAIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZDWAIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZDWAHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:07:54 -0400
Received: from smtpauth14.prod.mesa1.secureserver.net ([64.202.165.39]:36019
	"HELO smtpauth14.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751240AbZDWAHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:07:53 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 20:07:53 EDT
From: "Andrew S. Johnson" <andy@asjohnson.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: TMDC Joystick no longer works in kernel 2.6.28
Date: Wed, 22 Apr 2009 19:01:11 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200901101553.40515.andy@asjohnson.com> <200904200104.09483.dmitry.torokhov@gmail.com>
In-Reply-To: <200904200104.09483.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904221901.11703.andy@asjohnson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009 03:04:09 am Dmitry Torokhov wrote:
>
> The patch below should help with joysticks attached to gameports;
> it should appear in 2.6.30-rc3.
>
--patch snipped--
> --
> Dmitry

The TMDC joystick now works under 2.6.30-rc3.  I tested it with 
Google Earth flight simulator, Extreme Tux Racer, and Super Tux 
Kart and it all seems fine.

Thanks for fixing this.

Andy Johnson
Luling, Louisiana
