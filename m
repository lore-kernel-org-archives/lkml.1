Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZAKWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZAKWdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAKWd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:33:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:28264 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZAKWdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cs6LGqbJtBuO3gponT48feqja2GYOmRmz1lklkbY9mO0z9qCIpFD4GXKgaCQqO/M7p
         luvySa0OD6DLY/9Ueqf1h//ZDHB4u18s1jdXDK3dPWOxcegXjimKHsnxU/EGOIL/V7lO
         tEDDC0qZvxmQu/icwvF82V1WGzxllAhz+SOIs=
Message-ID: <496A73B1.3070208@gmail.com>
Date: Sun, 11 Jan 2009 23:33:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix commit_creds() on a process that has no mm
References: <20090108111831.27076.81306.stgit@warthog.procyon.org.uk> <alpine.LRH.1.10.0901082344470.15751@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0901082344470.15751@tundra.namei.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2009 01:46 PM, James Morris wrote:
> This looks correct in its own right, and is available for Linus to pull 
> per below, but I'd also like to know that Jiri's problem is verified to be 
> fixed.

It fixes the issue, indeed. Thanks.
