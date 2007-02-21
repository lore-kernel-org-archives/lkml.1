Return-Path: <linux-kernel-owner+w=401wt.eu-S1422733AbXBUSpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422733AbXBUSpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422648AbXBUSpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:45:11 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:44690 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422733AbXBUSpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:45:09 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 00/18] 2.6.18-stable review
Date: Wed, 21 Feb 2007 20:45:08 +0200
User-Agent: KMail/1.9.6
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr> <20070221173445.GA16071@kroah.com>
In-Reply-To: <20070221173445.GA16071@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702212045.10422.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 19:34:45 Greg KH wrote:
> On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.??a??lar Onur wrote:
> > 21 ??ub 2007 ??ar tarihinde, Greg KH ??unlar?? yazm????t??:
> > > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > > received after that time might be too late.
> >
> > We have still some CVEish patches in our package which maybe you want to
> > consider adding into -stable.
> >
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-4814
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5749
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5753
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5823
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6053
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6054
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6333
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0006
>
> Do you have a pointer to the patches for these fixes anywhere?
>
> And are you sure they are all for 2.6.18?  The first one above is for
> the 2.4 kernel tree :)

Yep and Mandriva fixed that in their kernel release which is 2.6.x, I mailed 
security@kernel.org about it some time ago, but got no response so far.

Regards,
ismail

-- 
FFmpeg doxy @ http://cekirdek.pardus.org.tr/~ismail/ffmpeg-docs
