Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYDTSHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYDTSHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYDTSHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:07:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:2688 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYDTSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bTtzu95Ln6xuktcfEQrCpfJyKj1FnCGk1tJjvicsSj+YrQKdj6oFErK0YEji0VhTWWZeKW0HkuGZFNVxtooWO1dOHMtT52BJ+eJix/BFkuR8/uienAQMHHQO9+hbvCLCCcntgwJ5DKSIrIiY3YN9CvrkYEhr3waAwZy/TSNE7Mg=
Message-ID: <480B865A.7040907@gmail.com>
Date: Sun, 20 Apr 2008 20:07:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: HID bus
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com> <480B6C16.40806@gmail.com>
In-Reply-To: <480B6C16.40806@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2008 06:15 PM, Anssi Hannula wrote:
> Oh, so we create a normal usb modalias entry anyway, not a custom
> 'usbhid:' one.

Arrr, thank you, this provoked me an idea. I'll repost the patch tomorrow or so.
