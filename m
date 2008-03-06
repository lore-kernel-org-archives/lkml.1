Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbYCFQMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbYCFQMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYCFQMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:12:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:47018 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYCFQMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:12:13 -0500
In-Reply-To: <7E836D6E-867B-4A35-9B3D-CD1D52E7F2DC@kernel.crashing.org>
References: <20080306135330.6d5462d2@vitb.ru.mvista.com> <7E836D6E-867B-4A35-9B3D-CD1D52E7F2DC@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <aece767c51f5ab68c3012f1446cdd569@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [POWERPC] 8xx: fix swap
Date: Thu, 6 Mar 2008 17:12:03 +0100
To: Kumar Gala <galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do we need similar fixes to arch/ppc ?

Do we care?

arch/ppc needs many fixes, when you have implemented all of that, you
get a clone of arch/powerpc ;-)


Segher

