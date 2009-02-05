Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZBETLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZBETLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759838AbZBETKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:10:32 -0500
Received: from smtp-prod01.osg.ufl.edu ([128.227.74.39]:41735 "EHLO
	smtp.ufl.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759325AbZBETKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:10:31 -0500
X-Greylist: delayed 5500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 14:10:31 EST
Message-ID: <1286126871.134901233855527575.JavaMail.osg@osgjas02.cns.ufl.edu>
Date: Thu, 5 Feb 2009 12:38:47 -0500 (EST)
From: "CHADHA,VINEET" <vineet@ufl.edu>
To: nickpiggin@yahoo.com.au
Subject: Fwd: Profiling IPI
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3061_572439824.1233855527563"
X-Mailer: GatorMail WebMail (http://GatorMail.sf.net/)
X-Originating-IP: 134.134.139.72 [134.134.139.72]
X-UFL-Spam-Status: hits=0.1, required=5, tests=RDNS_NONE
X-UFL-Scanned-By: CNS Open Systems Group (http://open-systems.ufl.edu/services/smtp-relay/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3061_572439824.1233855527563
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Sorry for repeated queries. I wrongly cc'ed email previously.

Regards,
Vineet

------=_Part_3061_572439824.1233855527563
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

I need to JUST profile overhead associated with interprocessor 
interrupt in terms of cycles consumed in a 64-bit Linux O/S. 
Assume I have 2-cpu system. I want to know cycles consumed to 
sending IPI, flushing remote CPU TLB and finally flushing its own 
TLB. Any help is appreciated.

Thanks in advance.

Regards,
Vineet

------=_Part_3061_572439824.1233855527563--

