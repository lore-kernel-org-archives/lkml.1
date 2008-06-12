Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYFLHCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYFLHCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYFLHC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:02:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:43152 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbYFLHC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=pn8W9Kxh6pseXFsBcLT/0hpILmwwNopullBPhsM+Ku5EV33OP6IWNDWotJfp7Tg/HY
         2kAdBxxLM8qw2a1KxlnF5IifLOvxJAbiHJb+hrb2jBfKuC/OGEtpWFjKaOIEhSV31mhS
         VUC3Ih2aV0vaQI0KyM4lI5cJtg6+SIdmuU6XI=
Message-ID: <4850C9F5.8000104@gmail.com>
Date: Thu, 12 Jun 2008 02:02:13 -0500
From: Elijah Anderson <kd0bpv@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 8139cp/too support not accessible?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey List,

I will admit right off the bat that I'm new to interacting directly with 
the kernel, much less building one.

The issue I'm having is that my ethernet card requires either the 8139cp 
or 8139too module. I don't remember which one, so I want to modularize 
them both. Problem is, using $make xconfig; I can't select it. I have 
the interface set to show me all the options, but the modules I need are 
grayed out and I can't change the value.

Using $make config; It doesn't show them, even if I say Y to "Prompt for 
development and/or incomplete code/drivers"

Is there a way to manually select those drivers for modularization, or 
am I just missing a step somewhere?

Thank you.
