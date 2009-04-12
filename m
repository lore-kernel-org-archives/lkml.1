Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZDLQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZDLQvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZDLQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:51:04 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40884 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZDLQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=apsOWamwd6itsycOtJJXenqZSnCp4P6uOWgL+wE6lnbC6U59C3CXLHE75Mim7jqW42
         wOqPbjek8cRCL4YaFW1KzpttP1QxVUXgMuxpPn3QvKbmF08KrHBCVQ7nXYW16+MwWmbD
         gT+IMagFp+nRUFdsUQ2SXoxYRRIb6xEGszShE=
Message-Id: <20090412164738.967602112@openvz.org>
User-Agent: quilt/0.47-1
Date: Sun, 12 Apr 2009 20:47:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: xemul@openvz.org, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       macro@linux-mips.org, andi@firstfloor.org
Subject: [rfc 0/4] x86 - apic dummy ops with cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a series of patches with some tiny
cleanup and one bugfix I believe (and most
probably why fixing one issue new one could
be introduced as well :-)

Please review and test if possible. _Any_ kind
of feedback is highly appreciated!

Cyrill
