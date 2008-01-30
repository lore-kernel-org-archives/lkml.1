Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYA3NxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYA3NxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYA3NxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:53:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:62150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYA3NxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BLu0gB5TtHzSN4SVQpuGWdlqeIEO+ng8NwNGCaOroKij+pUNlXshe0OCdXWd/DXOUAeLtjSzPcrUS5MLT+mlaNzXBifyddb77XFr7ABugn/sGR8Y0PvPd+c8VTzR8DnQQWgZAcm9hOh9e44myLmUy3645MNRPeHQCnfmZiX+WBA=
Message-ID: <47A0813C.8000809@gmail.com>
Date: Wed, 30 Jan 2008 14:53:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bryan Wu <cooloney.lkml@gmail.com>
CC: Robin Getz <rgetz@blackfin.uclinux.org>, Bryan Wu <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>	 <47A058B3.6000009@gmail.com>	 <200801300739.21344.rgetz@blackfin.uclinux.org> <386072610801300515j56d10f2ej55859500c91befbb@mail.gmail.com> <47A07F1D.9000208@gmail.com>
In-Reply-To: <47A07F1D.9000208@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2008 02:43 PM, Jiri Slaby wrote:
> specified one (like a v4l or tty layer, or chrdev_open aswell, which 

Eh, no, not the tty layer...
