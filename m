Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZCOKxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZCOKxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZCOKxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:53:09 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:1573 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbZCOKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:53:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAIJ5vElR88Bs/2dsb2JhbACBTc8Ug38G
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Robin H\. Johnson" <robbat2@orbis-terrarum.net>
Subject: Re: [PATCH UVC] Add UVC entry for Logitech Quickcam Orbit AF.
Date: Sun, 15 Mar 2009 11:53:36 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.28; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1237080405-13437-1-git-send-email-robbat2@orbis-terrarum.net>
In-Reply-To: <1237080405-13437-1-git-send-email-robbat2@orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151153.36688.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

On Sunday 15 March 2009 02:26:45 Robin H. Johnson wrote:
> Need explicit entry like many of the other Logitech devices as it does
> not match the class otherwise.

Are you sure about that ? The Logitech Quickcam Orbit AF I got here matches 
the standard UVC class. Could you please post the output of

lsusb -v -d 046d:0994

on your system with the camera plugged in ?

Best regards,

Laurent Pinchart

