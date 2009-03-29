Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZC2Ttq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZC2Ttq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZC2Tth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:49:37 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:22002 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZC2Ttg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=XkFDBFDw2u9o6/UoOYUdVgpPyvoGoeBUx2lfe1dVEFgfHGyxXPEFOPnZCPfGh2Jx3H
         1cQR/DfXB0rWh7KQ7DHA3HGnrAlnlDr8u9Av77V7lEj6WuiiBphm5gpRC+NgWwjGgkpJ
         2475p8RRGu1o1LLH5kx4RpPh4HgHWmpZROhFA=
MIME-Version: 1.0
In-Reply-To: <1abf13da0903291247y124e866doc6cb66704c8de137@mail.gmail.com>
References: <1abf13da0903291247y124e866doc6cb66704c8de137@mail.gmail.com>
Date: Sun, 29 Mar 2009 15:49:33 -0400
Message-ID: <1abf13da0903291249n4f5435d8nb24caca2c80a3048@mail.gmail.com>
Subject: Re: Getting vesa modes list from userspace
From: Sam Varshavchik <sam.varshavchik@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With vga=ask boot prompt, I notice that the list of available vesa
modes varies on my laptops. Some video modes (the same width x height
x depth) show up with different values on different machines.

Is the list of video modes supported by the hardware available
somewhere? I looked in /proc and /sys, and did not see anything
obvious.

(please cc on replies)
