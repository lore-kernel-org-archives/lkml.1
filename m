Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZGLIRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZGLIRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZGLIRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:17:23 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:45454 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZGLIRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j2ajx7LYBnri8qhC45bLDUtSOoXJp/s+wrKBxVRtMO31N/X3evtkkVz7i/dzzj8Lqk
         JNKt+/bJaz/Px2pV/H7OyUYP1a0kGTzffaT8S4TR6pYR91sFz18n3GjGdZOFXy9IKqhD
         uYG3RddokxFxJYG6IFrGkITtJLMwgQ2if6SlE=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 01:17:19 -0700
Message-ID: <86802c440907120117g7e9a5f41o915c4aefa49788dc@mail.gmail.com>
Subject: e1000e with kexec
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e1000e in second kernel doesn't work again.

YH
