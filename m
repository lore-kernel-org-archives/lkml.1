Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYLGVzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYLGVzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYLGVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:55:12 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:35716 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYLGVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UVPAfmcawaUYQRYx3aZTJP/Hq2Cg0CdR6bHoIoe6mYqI4ZRAcH+Ky2lJrHqDgE49VX
         ulfJVQT/XQYvQ/cjMHk2Q7BaBdXouKn+R1AV5f7yN6JShJ/SP+hwj4ITp48ssBeRUpPe
         rt+v3e1beIIn5jWG5txKpl6nxNRs/8z8hih+A=
Message-ID: <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
Date: Sun, 7 Dec 2008 22:55:10 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <493B4242.1040202@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AE770.5030507@shaw.ca>
	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
	 <493AF2EA.4030601@shaw.ca>
	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2008 at 4:25 AM, Robert Hancock <hancockr@shaw.ca> wrote:
>
> If it only happened once then who knows, could be a cosmic ray or
> something.. but if it happens again it sounds like you likely have a bad
> CPU.
>
This same MCE happens every time I boot the 2.6.27.8 kernel, but it
never happens with kernel 2.6.26.8. It appears every time at log time
[  301.7320xx](where the x represent the scale of the approximation).
In the previous log it appeared at [  301.732037], now it appeared at
[  301.732042]. It happens just once at that moment and then never
more until I reboot. No MCE gets logged with kernel 2.6.26.8 nor with
Windows Vista 32bit, not even under very heavy load on memory and
cpu(like 3d games or 3d mark vintage). Is this really an hardware
problem? Why does it get logged only on kernel 2.6.27.8 at that exact
moment? Now I'm gonna compile kernel 2.6.28-rc7 and see if there it
happens too. Any suggestion? It would be appreciated, because,
depending on the final result, I may be forced to change the
hardware(It's still guaranteed, but it'd mean some months without a
pc).
