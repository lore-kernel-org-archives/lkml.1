Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZBVPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZBVPRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 10:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZBVPRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 10:17:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:28096 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZBVPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 10:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Pd2RlPxbC4K2p1pAHcWoInTe6zA1WCTIiqLGOqqf1dkhBBp+YeIvVvXwhE+fBkU03d
         mdCAsM2D+NForkyKMh5OG9dmAM7U/i1iMwXWAbjuWeZ4COtRJZJsxZbUD2JocjB1nYiX
         4MgXp51b0+YQZCw/FEoDxpQ3lPi1Q0ueDTQ2A=
MIME-Version: 1.0
Date: Sun, 22 Feb 2009 17:17:41 +0200
Message-ID: <dfb262380902220717y7e778695yeee67a7ce87ca314@mail.gmail.com>
Subject: is oprofile alive ? (and some more questions about it)
From: Ramagudi Naziir <naziirr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello all,

i've noticed that the last oprofile release was at July 2008
(http://oprofile.sourceforge.net/news/)

is oprofile still alive ?

If yes, where can I read about its up-to-date status (there is nothing
in Documentation/ about it..) ?

I've seen several comparisons between systemtap to lttng to dtrace but
never has oprofile been mentioned.

can anyone please help me understand how does oprofile differ from
those projects ?

thank you everyone in advance
naziir
