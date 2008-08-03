Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYHCSaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYHCSaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYHCS34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:29:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11323 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYHCS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QMC1aPd482kvmKDkbMyfSOGoSHXL4fF1NN4z72w/Io7qJgIrB/uqURpJCVzwTdqHV9
         aAz2phgIxYUc6l6b5ihKjiZyJg9GOMB5S079dqycB0Phr41IijzJNplDI17lrbUD+Cgj
         Nu4pt94xmn21vgR8GjzOc2mCFMMwOifjLazDc=
Date: Sun, 3 Aug 2008 20:29:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <len.brown@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: acpi error on 2.6.27-rc1+ (ACPI Error (dsobject-0501))
Message-ID: <20080803182913.GB8691@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I noticed that 2.6.27-rc1+ (2b12a4c524812fb3f6ee590a02e65b95c8c32229) prints this:
Completing Region/Field/Buffer/Package initialization:.ACPI Error (dsobject-0501): Package List length (EA) larger than NumElements count (3), truncated

Is it something to worry about?
I've put full log, config and acpidump on http://www.kadu.net/~joi/kernel/2008.08.03/

Marcin
