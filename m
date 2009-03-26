Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbZCZXe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbZCZXe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZCZXeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:34:50 -0400
Received: from eastrmmtao107.cox.net ([68.230.240.59]:40367 "EHLO
	eastrmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZCZXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:34:49 -0400
X-Greylist: delayed 3563 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 19:34:49 EDT
X-Authority-Analysis: v=1.0 c=1 a=5DpXERbgOHSuG6ebSiIA:9
 a=_qvrAfbDX7wXqJYSl8wA:7 a=XNp8HCCRyhwTnlLRUklc58PQzlEA:4 a=77UB_OrJ-6MA:10
X-CM-Score: 0.00
Message-ID: <49CC032C.20001@cox.net>
Date: Thu, 26 Mar 2009 18:35:24 -0400
From: Mark <mbeauch@cox.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: compressed elf core dumps
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I have a patch set based of a slightly older kernel which offers compressed(gzip)
core dumps. These files compress exceptionally well.  This feature can be 
helpful for embedded linux systems with smaller file systems.  The core dumps 
can be taken off line, un-compressed and analyzed.  
 
If there's any interest, I'll update the patch and post it.


