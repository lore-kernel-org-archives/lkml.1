Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZHLGUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZHLGUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 02:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZHLGU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 02:20:29 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:40896 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZHLGU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 02:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=CqGAzhWZwT+Ybu4AF7+/sIu56pBaZJDW6DztxAQWzi42rT7YVmQBc7pF8QO2wpECev
         wtcI5pSWlaL/x7PQys/wmy/C40FlneFrtX0LrvmwfX33lSsJoS/JMIIcmALBBbzUVIUs
         bXwRXx3ekJv/g9b2EL7OQxluSk4BMs1nQFF1E=
MIME-Version: 1.0
Date: Wed, 12 Aug 2009 11:50:29 +0530
Message-ID: <241b8f7b0908112320u44519e7fnfbc4fa96667cdb20@mail.gmail.com>
Subject: about CONFIG_CMDLINE
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  In kernel_hardening activity, I am setting CONFIG_CMDLINE, to

CONFIG_CMDLINE is nit set.

But while building, it is prompting to select its state(y/n).

I want to disable this prompting, how can I do it ?

Any idea, please share ...

Thanks in advance,
Prahu
