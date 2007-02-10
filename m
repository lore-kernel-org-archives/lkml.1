Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbXBJB77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbXBJB77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXBJB76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:59:58 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:7518 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbXBJB74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TS7U/CRkUXyIedotSR7pM2XTZJDkctcZ4yQELAT/jfW4wO3frf09WwUEO+YbC+zR+IIAD+Ayecd9ZXMoh3/uJRh+N6czYYMJLzbOtdqdCMXkUlImQIlHgmiO9WV1PK6m5xQHjFMVdJZmsF14i2/upZ6O6GY+OdesM7lNag/EXe0=
Message-ID: <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
Date: Fri, 9 Feb 2007 20:59:55 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, nigel@nigel.suspend2.net
In-Reply-To: <45CD24F6.8090107@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
	 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca>
X-Google-Sender-Auth: 4cc9e63137baa1c7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Robert Hancock <hancockr@shaw.ca> wrote:
> I would disagree that it's a peripheral issue, it's pretty core these
> days, at least for any hardware that you can stuff in a laptop (though a
> fair number of desktops get suspended and resumed these days too).

Servers are still the most important Linux market, and don't care
about suspend/resume.  I would consider implementing suspend./resume
for a driver that will only be used in server or HPC class hardware a
waste of valuable development resources.

Lee
