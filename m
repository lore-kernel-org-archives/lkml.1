Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbXH3NAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbXH3NAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbXH3NAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:00:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:8816 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXH3NAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Fmw4wGWvb1olX8DTPWlhRd4EmLU+hJMqyXLhix4yi1kIMZryudW4y2bCF7uEo12DUwvlMEXMO+zELmlavnjEOAjN3GHYaEVq22hMBIhZa6Pumu2i/6P6my9Xn4Q1fkMGkRVldxOGbcSzlkKCbeFsGS8p92aGSuZyq21LJcN8COk=
Message-ID: <40378e40708300600h5837d46ci5266b8ae62bbd46e@mail.gmail.com>
Date: Thu, 30 Aug 2007 15:00:29 +0200
From: "Mohamed Bamakhrama" <bamakhrama@gmail.com>
Reply-To: bamakhrama@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Average number of instructions per line of kernel code
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have a question regarding the average number of assembly
instructions per line of kernel code. I know that this is a difficult
question since it depends on many factors such as the instruction set
architecture, compiler used, optimizations used, type of code, coding
style, etc...
I would like to know a rough estimate for such a quantity for the
kernel 2.4/2.6 code running on MIPS32 architecture.
My estimate is between 5-10 instructions. I googled for such a thing
but couldn't find any useful papers/resources.

Many thanks in advance.

Best regards

-- 
Mohamed A. Bamakhrama
