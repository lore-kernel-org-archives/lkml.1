Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYKLRgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYKLRgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYKLRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:36:12 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:46269 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbYKLRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:36:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=qSTV+rRbFqiob3/Z9Gh0KBPAuvDHJVuk6qqBUPSdBBa8atDxAC60ky7Y2sj3URJE;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <491B1409.9040705@earthlink.net>
Date: Wed, 12 Nov 2008 12:36:09 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.27.2 hda-intel weak sound from speakers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79f86fd22e9cdf90a598e58ebcfe3d17be350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running linux 2.6.27.2 ontop of a Fedora 8 distro. The sound from the 
speakers is barely audible with all the mixer settings at max, this includes
the pulseaudio settings. This is on an ASUS laptop with intel-hda. I ran
alsa-info and the results are at:

http://www.alsa-project.org/db/?f=7c83d3e5d89101f8e9a0a4aa18cd76f499e02fda

There has been some minor improvement in the volume over the past year I have
had the laptop. I am hoping that someone can identify a way to make the sound
loud enough so I don't have to put my ear by the speakers to hear the sound.

Any insight would be greatly appreciated.

Thank,
Steve



