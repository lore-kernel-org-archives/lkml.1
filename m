Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbZACCrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbZACCrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbZACCrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:47:39 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:24442 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbZACCri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:47:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=F8TPOYnjPkqLS4e8oeq7KEF2q4hnKo4imcHjbiTNmboLqCb0NtEImw83qFWSsB1fCj
         jNekasfFCCw/L8M52aRriqMRUCoqtRNxlOCHmqjg7bGjW7fWCEKmNeUNbx8QMpgGDKik
         ruDc/CjvFGuHt4ixMx0IhKJVrcKREDMmKXpOw=
Message-ID: <495ED1C4.8020304@gmail.com>
Date: Fri, 02 Jan 2009 18:47:32 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ath9k microwave anomaly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I'm not trying to be funny,
but I think I figured a problem
with running ath9k, and having the internet
timeout.(for me at least);
When streaming T.V.(cspan2), and
streaming music(somafm), at the same time,
then using the microwave, I'll experience a blackout
of internet(T.V. stops, then music stops streaming);

not sure if this is caused by the router or not, but
when I set the router to channel 3, I can
connect back after the blackout, but if I set the channel to 6,
it seems the only way to get back up, is a reboot.
the distance from the microwave is probably
15 to 20 feet.
How can I really test this to see if this is the module,
or router that is being interfered with.
(I did set myself between me and the router(no blackout),
then me the microwave, router(had a blackout);

I hope this helps with some of the weirdness
I've been hearing about with timeouts.

regards;

Justin P. Mattock

