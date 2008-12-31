Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYLaIsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYLaIsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYLaIsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:48:39 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:48679 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYLaIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:48:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JJb+24N0HcgvNE+zXSsPfEWWpJVXpRhU1zM/tvJVNhHY9lAWcmlaz8vtlvIPGfbTW4
         P8t2I6uA0FThuQpaMG6pfeoV4hc1DoeI0rSEZPooXWmx385ZC/OQOERNqMNC30bb2CuC
         goRuzd91kz2lbbS2NcObIDETKG67TQvdn40L8=
Message-ID: <495B31E2.6000801@gmail.com>
Date: Wed, 31 Dec 2008 00:48:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: snd-hda-intel no front mute switch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if I have my configurations correct, but after
pulling the latest git, I notice that my mixer has no switch to mute
the "front", or external speaker on a macbook pro(ati chipset);
other than that the sound sounds really good.
(solution I guess: plug-in headphones, and mute headphone option);

regards;

Justin P. Mattock
