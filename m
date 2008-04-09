Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYDIE2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYDIE2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 00:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYDIE2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 00:28:33 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:39954 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYDIE2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 00:28:33 -0400
X-Greylist: delayed 2752 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 00:28:33 EDT
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: DRDY errors again
References: <E1JjLYm-0002d7-00@calista.eckenfels.net>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 08 Apr 2008 20:42:36 -0700
In-Reply-To: <E1JjLYm-0002d7-00@calista.eckenfels.net>
Message-ID: <87d4ozpuc3.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels <ecki@lina.inka.de> writes:

> Besides the disk it could also be a voltage problem (voltage control on
> mainboard or power supply). I asume you ruled out thermal problems...

I would completely second that.  In multiple instances, I've had
different disks behave very strangely when the power supply became
flaky (12V at 11.3V and/or 5V hovering around 4.5V).  And there seems
to be lots of flaky power supplies around these days.

Phil.

