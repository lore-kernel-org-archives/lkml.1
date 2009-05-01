Return-Path: <linux-kernel-owner+w=401wt.eu-S1765486AbZEAO7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765486AbZEAO7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763279AbZEAOvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:51:06 -0400
Received: from web112201.mail.gq1.yahoo.com ([67.195.14.64]:24041 "HELO
	web112201.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761868AbZEAOvE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:51:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=j8klozav+/i+yfB/7GHVHmLM6q5LJg2PqaF5s0+q0ar109gOb8OZUL6/wDtcuuDZpTmZWl5prFDqGnKqJGpsQ7R8K814lPwxRZZZG/qDXOmHcYPdN2g4m+PAEhGX22O1zn77xX3Mhko8ZmB1cmtW+JkSe6N2He+lWtY8rukbYcY=;
Message-ID: <335220.92184.qm@web112201.mail.gq1.yahoo.com>
X-YMail-OSG: pyFcQ1sVM1ntddzs1ecjNVyd3kj3HkG0r2hXAL7eDd9dnDdWeG0_KKaepEtrTdVNPuh0ZcXv0Bst9FUoRz73pT2zVlADAB768HMf07S3WSkktrSPdrFoZDBKPnKLSDynwYh14AyRgZ.JBHF5stWd4hBitjbIZ0niRNg3FWqs2jBJc53D8_PWT_yfBi6tM5ifEjmB8MomGjtGGrGozlzCF6YEZaPnh1xqWTlQFhnhQTnEhbrkZhDbhQDLYv1y2YqVDvuogYCvYhjXwXAkhyZv5XN6iCyrwq3fsirFs0jFrvr1VJZQFmQSwoSoEHZfp8T_4lu87kO1he1VDPFkEL45ydbb4ahJ39EWdfjuyiK6pIWDW5_ROXBCBPLB.Q--
X-Mailer: YahooMailClassic/5.2.20 YahooMailWebService/0.7.289.1
Date: Fri, 1 May 2009 07:51:00 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: regression with video and i915 module
To: akpm@linux-foundation.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
       davidjon@xenontk.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If its necessary or useful for searching the error or reason for that problem, I put the compilation / install protocols of 2.6.30-rc4 on the server (too big to add to this mail service) so that can be analyzed the compilation error / info messages:


http://guyane.dyn-o-saur.com/sys/linux-2.6.30-rc4-i486-1sys.log1  , ...log2 , log4 , log5   (.tgz is the compiled kernel package)

If my laptop is switched off then, later, it can be also download from a mirror, f.ex.     http://ftp.tu-chemnitz.de/pub/linux/SYS/


I still inform that beside of this problem, I didnt see other relevant problems with that kernel, it also runs normally on my computer,  http://guyane.dyn-o-saur.com/info.php



W.landgraf



--- On Fri, 5/1/09, We La <w.landgraf@yahoo.com> wrote:

> From: We La <w.landgraf@yahoo.com>
> Subject: regression with video and i915 module
> To: akpm@linux-foundation.org, lenb@kernel.org, linux-kernel@vger.kernel.org, davidjon@xenontk.org
> Date: Friday, May 1, 2009, 4:34 AM
> The error messages with 2.6.30-rc4
> are more than before:
> 
> Apr 30 23:35:17 localhost kernel: i915: Unknown symbol
> acpi_video_exit
> Apr 30 23:35:17 localhost kernel: i915: Unknown symbol
> acpi_video_register
> 
> This is like before a MSI wind U100 laptop
> 
> 
> On this ocasion, I want to mention that also the broadcom
> 43 wifi driver dont work correctly. This cards are in HP,
> Compac, Toshiba laptops.  The driver needs additionally
> the extraction of firmware from Windows drivers and
> installation in /lib/firmware, and even then it functions
> problematically. Often nor the light that the wifi works
> goes on. The programmers of that should be notified to
> repair the driver that he dont depend longer on firmware.
> 
> On the same time, the rt2860sta driver for wifi on my own
> laptop works without problems, my server works via wifi with
> this driver and I up-/download many, no problems with that
> driver.
> 
> 
> Werner Landgraf
> 
> 
> 
>       
> 


      
