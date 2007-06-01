Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbXFAWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbXFAWUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXFAWUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:20:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:12614 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXFAWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cfsKOCTn7O+lau3yK30YhTv3xllYJI25FD6Cp1lIIc0qPC7Z/Jth0ZHy6o/tJEvLWRgVJG7pJTQ9UcZAL+9ZYYGXZSs8gX64dWvyswsXdldYrG7GvH5iSTxMpAourepu6BRfx37x7xtSwxXOcd+1tOQBJ55SPTTMwVmxdP5rumk=
Message-ID: <e38d12ff0706011520n4d6f00cdt80a4ead3d939c849@mail.gmail.com>
Date: Fri, 1 Jun 2007 18:20:02 -0400
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: tickless timer support on non-x86
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I want to use the tickless timer features in 2.6.21, but
unfortunately, the dependency for tickless timers is
GENERIC_CLOCKEVENTS (and tickless is only in arch/i386).

Any workarounds or solutions for non-x86 people?

My CPU is AMD Turion ML-34.
