Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYCaBcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYCaBcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 21:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYCaBcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 21:32:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:22373 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYCaBco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 21:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=J2V6d8VLrjLwY+iHteokEK16jMhE8EI+UXrdLnK7eBFZ4i3jG7bBQWxnjQYiO9acR264idc8/lVfqbKqXHzbRYR72Wg8kRxD9ti3pBqX8LdUW58givHoO9NTvebc9+kVHEkqcNLBn/ThzqoNGf3R3dM4x70PulXlBtXEjvT9z54=
Message-ID: <47F0418C.8080407@gmail.com>
Date: Mon, 31 Mar 2008 09:42:36 +0800
From: Peter Teoh <htmldeveloper@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Subject: blktrace debugging:   how to use it
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is patch is to enable blktrace debugging in the kernel:

http://lkml.org/lkml/2006/8/1/405

Can anyone provide any guidelines or references on how to use this 
feature from userspace?   Any tools written to TEST and use this feature?

Thanks.
