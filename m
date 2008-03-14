Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYCNPmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYCNPmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCNPm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:42:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:57329 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYCNPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=dNIFiOOK3ttl+DvRleqZWq3IGvlg/pAqiIazib2xfu2xG0uUfTRIp1EJ4OdOcgISujlh3YNGqpowIXl7r+u9wivfWz42o14cThyiyAcS2VLbUTr1E7i9khJT78lyqJx9T/5gtstZ81TdvAG44Qriruix2DxlmzqTyfoPXiAC/XI=
Message-ID: <47DA9CDB.2090707@gmail.com>
Date: Fri, 14 Mar 2008 16:42:19 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrus Massoumi wrote:

> FreeBSD does not outperform Linux, it's actually a bit faster according 
> to Nick's tests.
> 
> I cannot comment on BIND and NSD, but SPECjbb looks pretty close and the 
> bad ebizzy performance seems to be an issue with glibc's memory allocator.

DNS test was a request from BIND team:
*BIND 9 performance while serving large zones under update*
<http://new.isc.org/proj/dnsperf/ISC-TN-2008-1.html>

more tests FreeBSD vs. LiNUX at http://jeffr-tech.livejournal.com/

-thanks-

regards,
-- 
so much to do, so little time.
