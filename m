Return-Path: <linux-kernel-owner+w=401wt.eu-S1030505AbXECJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505AbXECJAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXECJAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:00:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:49587 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505AbXECJAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:00:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: Mysterious RTC hangs on x86_64 - fixed, sort of
Date: Thu, 3 May 2007 11:00:11 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>, Marcos Pinto <markybob@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
References: <46391253.30201@vmware.com> <46391716.9040001@redhat.com> <463963AE.5010300@vmware.com>
In-Reply-To: <463963AE.5010300@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031100.11863.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Enough crashing for today.  Strangest thing is the NMI watchdog does not 
> fire...

It's disabled now by default.

-Andi
