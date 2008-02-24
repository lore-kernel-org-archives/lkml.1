Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYBXJ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYBXJ6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 04:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYBXJ6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 04:58:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28253 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYBXJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 04:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=g0r36AgHfvzN8nK4XZ/Tvui2Xqqc9Dmx/a313nScA8D+lH9/60YNUZlksB4HlWRzQcEBNIP9b+So3WWhHeyxHZJo3J7sAOxNWIROtcFFRlREThxGH7TY8N0xNHvGr35ye6m5WBrmDeebFiVHfiZvrs0okcC1rFrXmwLUWXOX6Ww=
Message-ID: <47C13FA9.8000806@gmail.com>
Date: Sun, 24 Feb 2008 10:58:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Remove "obsolete" digiepca content.
References: <alpine.LFD.1.00.0802091643030.28397@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0802091643030.28397@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2008 10:45 PM, Robert P. J. Day wrote:
> Remove the Digi Intl. epca driver for Linux, which is marked as
> "obsolete."
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
>   this is a quick, first pass at a removal.  feel free to suggest
> tweaks.

Was there any comments on this? I suggest reposting with Cc to akpm.
