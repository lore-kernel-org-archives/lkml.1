Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZFCNB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZFCNB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZFCNBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:01:20 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:47780 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbZFCNBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:01:20 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Neil Brown <neilb@suse.de>
In-Reply-To: <18981.62579.171350.910761@notabene.brown>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
References: <18980.48553.328662.80987@notabene.brown> <4A25876A.1010901@garzik.org> <18981.62579.171350.910761@notabene.brown>
Message-Id: <448D5698-81A1-4100-8AF5-B6660D96ECE9@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Date: Wed, 3 Jun 2009 14:01:12 +0100
Cc: Jeff Garzik <jeff@garzik.org>, linux-raid@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

Is there any documentation for the interface between mdadm and a  
metadata format "module" (if I can call it that way)?

What I mean is: where would one start if one wanted to add a new  
metadata format to mdadm?

Or is the only documentation the source code to mdadm?

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

