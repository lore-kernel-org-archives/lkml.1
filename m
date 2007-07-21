Return-Path: <linux-kernel-owner+w=401wt.eu-S1765630AbXGUNeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765630AbXGUNeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758337AbXGUNeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:34:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:52363 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbXGUNeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eWRiy10zckq8A9DLdTO9OOsfcd6I6ZRlryQoTh/7+jBDGXjU2087qusVVuRAW86JRWLtPxzD6hJ/6MP3XWpdU3rj/M1RZhyt4fWoEDEdNTaVagidLafXWiVGfBFACkR9sXtTnJULcaZ+9K6zJabfVK99TyfPizDi7unviZe9lf8=
Message-ID: <4104961b0707210634gea4e240x11b043b4e64c7840@mail.gmail.com>
Date: Sat, 21 Jul 2007 21:34:09 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: what does select statement mean in Kconfig file?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
for example, what does the select statement mean?

config SERIAL_SH_SCI_CONSOLE
        bool "Support for console on SH SCI(F)"
        depends on SERIAL_SH_SCI=y
        select SERIAL_CORE_CONSOLE

Thanks
Jason Xiao
