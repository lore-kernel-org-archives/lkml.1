Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXAZUYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXAZUYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161148AbXAZUYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:24:14 -0500
Received: from dhost002-70.dex002.intermedia.net ([64.78.20.36]:58609 "EHLO
	DHOST002-70.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbXAZUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:24:13 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 15:24:13 EST
Message-ID: <45BA6018.5040406@genius.com>
Date: Fri, 26 Jan 2007 12:10:00 -0800
From: Khai Doan <khai@genius.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.13) Gecko/20060414
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to create a fixed length character/block device/file ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 20:10:03.0776 (UTC) FILETIME=[F73CC800:01C74185]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if this is the wrong list.  I've search google, but have not found 
solution to my problem.

I have a long running application which split out lots of debugging 
information.  I can't redirect the output to a regular file because that 
file would grow and eat up all the diskspace.  I can't redirect to 
/dev/null.  What I want is the last 1MB of the output before my 
application terminated.  So I need to create a special file / device on 
the system.  Please tell me if  there is an existing device that I can 
use, or point me in the right direction so that I can role my own device.

Thanks
Khai Doan
