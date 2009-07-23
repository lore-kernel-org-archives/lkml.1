Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZGWJhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZGWJhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 05:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZGWJhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 05:37:22 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:42778 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZGWJhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:37:21 -0400
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 10:37:19 +0100
X-Google-Sender-Auth: da35b12a81aec096
Message-ID: <b2cdc9f30907230237s18061c0g33625c055831b901@mail.gmail.com>
Subject: drm:i915_gem_execbuffer *ERROR* Object ffff8800af136f00 appears more 
	than once in object list on 2.6.31-rc4
From: Alex Bennee <kernel-hacker@bennee.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finally have a working KMS setup but I'm seeing the the following
scary looking messages in dmesg.
Should I be worried? Can I generate more useful output for anyone?


[  153.314004] [drm:i915_gem_execbuffer] *ERROR* Object
ffff8800af136f00 appears more than once in object list
[  153.391213] [drm:i915_gem_execbuffer] *ERROR* Object
ffff8800af136f00 appears more than once in object list
[  209.110632] [drm:i915_gem_execbuffer] *ERROR* Object
ffff8800af136f00 appears more than once in object list

-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
