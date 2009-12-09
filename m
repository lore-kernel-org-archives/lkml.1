Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZLIJEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZLIJEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZLIJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:04:36 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:44785 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZLIJEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=miRY1M+BuGybP9tjJVkE1GGMOtSohnrVjhqryo4nh+9tEAgqBVGsp+i5N9cTg5aT0p
         h/J/C2eW9zOihlPjEWks5R0OJ/iWrzdgrg9l1CI3R1rIz5TzxJBDUUKrq2aYb8O4wOhM
         naDzA//Aa58LDE1dng/1OUh4x7m39hRxpS3q4=
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 11:04:39 +0200
Message-ID: <82cfbe860912090104j3a064b4fs87faa9f5ef47ffe1@mail.gmail.com>
Subject: scaling_setspeed doesn't change the frequency on beagleboard
From: tarek attia <tarek.m.attia@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm using the beagleboard ,and android linux kernel obtained from the
rowboat project .

The cpufreq files are located and everything works fine except that
it doesn't change the frequency it works on,I echo'ed the
scaling_governor to use the userspace .

However it still doesn't change the frequency I'm typing also I'm sure
that my frequency is in the valid range .

What may blocks this changes ?

Any Idea will be appreciated  :)

-- 
tarek
