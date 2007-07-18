Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbXGROH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbXGROH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXGROHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:07:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:13158 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbXGROHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HmkQh9xmpydjv5BhXKjzlVg/8pboqtUqAGv/vyQ7NGe+W3ewmuSj+tCu2snXbDux5lFnsUqsiF0jTtPuc0sSZPdNxqqiLLKvwxxtb/ZHb6HHXmH7lnfpf8TXdtBDZTadXXJx1MhERB9KdbCLqcuJySF5ZUWIBqqbXpiQPKi2/ko=
Message-ID: <64d833020707180707i1bbbbcbao783e33a2487c9e2b@mail.gmail.com>
Date: Wed, 18 Jul 2007 10:07:48 -0400
From: koan <koan00@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RE: Slow Soft-RAID 5 performance
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How did you create the ext3 filesystem?

Did you use the appropriate --stride option as noted here:
http://tldp.org/HOWTO/Software-RAID-HOWTO-5.html (#5.11)
