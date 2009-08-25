Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZHYHTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZHYHTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZHYHTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:19:09 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:59089 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZHYHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc
         :subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZyxxB+JVvSym05J2LMu5ErVNHTypP3wAzXrK7CVuL1/+4C19gqUE4JYsfH1AKAqZv1
         DOk7T38LQFgDT7yt0vCUXy9V/Z5dK/vCljv5+glPUidF6nv7z9qetfLNqJhGn9uxKm7O
         IiCd2UUfmZ9nkd/SqeZoeIpQ3FmEVRQL7Ck9M=
Message-ID: <4A93903F.3080005@gmail.com>
Date: Tue, 25 Aug 2009 15:18:23 +0800
From: Xiangfu Liu <xiangfu.z@gmail.com>
Organization: openmobilefree.net (PI project)
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-input@vger.kernel.org
Subject: what is the meaning of matrix_keypad_platform_data.active_low 
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
./include/linux/input/matrix_keypad.h 
there no help in matrix_keypad.h about active_low.

I guess. when set active_low to 1.means:

0: key press
1: key not press

right?

thanks for help.

-- 
Xiangfu Liu
Email: xiangfu at qi-hardware dot com
Web: http://www.qi-hardware.com
