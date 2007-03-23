Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXCWKED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXCWKED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXCWKEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:04:01 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:8430 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422759AbXCWKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VlmizOCwmmfciSSabz7mhOHtbjCcMS2dCFnEOwV2RsBFOBrkv8FGuNX6cNnTyr6yahBaD0LzXIPibMtqCxDr0aFxiXWVibvvIKt7/vghJLPNfhtFWTY+3I7jRhAqdVlBtjWgHcS6pa2/G4K7R19GDwzsDZU1s58+AHXWAydTarI=
Message-ID: <f4e165120703230304p333124abmf7cce66d73a170fa@mail.gmail.com>
Date: Fri, 23 Mar 2007 18:04:00 +0800
From: hutuworm <hutuworm@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about CPU flags detection
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I just installed Red Hat Enterprise Linux AS release 4 (Nahant Update
4) on a Dell PE1950 server, which has two of dual-core Xeon 5110
1.6GHz CPUs. According to the processor spec @
http://processorfinder.intel.com/details.aspx?sSpec=SL9RZ , it doesn't
support Hyper-threading technology, but both 'cat /proc/cpuinfo | grep
' and 'dmidecode | grep -A 30 Flags' commands show there're "ht" or
"HTT (Hyper-threading technology)" available.

I think it should be kernel level's problem, is there anyone to
explain it please?

Thank you.

Liang Feng

-- 
In doG We Trust
