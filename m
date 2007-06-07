Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbXFGNMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbXFGNMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXFGNMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:12:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:38607 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751205AbXFGNMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:12:30 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/3JsRfSzb34uj+C9PXTXnnujtSFNpu3XJ9KSrM9p
	oYIwPcURUd6H9o
Message-ID: <4667A655.1040909@gmx.net>
Date: Thu, 07 Jun 2007 08:31:49 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: emogenet@google.com
Subject: man-pages-2.52 and man-pages-2.53 are released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"A foolish consistency is the hobgoblin of little minds, adored by little
statesmen and philosophers and divines"

         Ralph Waldo Emerson (1803-1882)

But damn it, those man pages were a mess!

Perhaps for the first time in their 14-year history, the sections in all of
the pages on man-pages are now in the same order...  The standard order
(with many sections being optional) is now:

            NAME
            SYNOPSIS
            DESCRIPTION
            RETURN VALUE
            ERRORS
            ENVIRONMENT
            FILES
            VERSIONS
            CONFORMING TO
            NOTES
            BUGS
            EXAMPLE
            SEE ALSO

So, I just released man-pages-2.52 and man-pages-2.53.  As well as that
change, there are a very large number of changes to achieve greater
consistency across man pages; full details can be found in the change logs.

In the upcoming man-pages-2.54 release, a new man-pages.7 page will
describe the conventions that should be followed when writing pages for
man-pages.

These releases are now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages
    or mirrors: ftp://ftp.XX.kernel.org/pub/linux/docs/manpages

and soon at:

    ftp://ftp.win.tue.nl/pub/linux-local/manpages

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

