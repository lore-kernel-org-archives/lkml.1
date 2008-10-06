Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYJFLQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYJFLQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 07:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYJFLQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 07:16:26 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:54784 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYJFLQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 07:16:26 -0400
Message-ID: <48E9F388.8040203@diamondcut.com.br>
Date: Mon, 06 Oct 2008 08:16:24 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rjwysocki@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
Subject: [Bug 10797] Battery is drained after poweroff
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can someone help us with this bug?
<http://bugzilla.kernel.org/show_bug.cgi?id=10797>

Same problem is reported in Ubuntu:
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>

This is not a hardware problem, because if the same laptop is poweroff
by Windows, battery charge don't change.

And, if I suspend to ram/disk BEFORE poweroff, battery charge don't
change (suspend to ram/disk --> WakeUp --> Poweroff).

Best regards,
Renato
