Return-Path: <linux-kernel-owner+w=401wt.eu-S2992994AbXBRBoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992994AbXBRBoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993021AbXBRBoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:44:30 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:59159 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S2992994AbXBRBoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:44:30 -0500
Date: Sat, 17 Feb 2007 17:28:16 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Trent Waddington <trent.waddington@gmail.com>
cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <3d57814d0702171726l403c7812n19f2a226cba02e5d@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0702171712010.12155@qynat.qvtvafvgr.pbz>
References: <20070216125353.GN13958@stusta.de>  <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
 <3d57814d0702171726l403c7812n19f2a226cba02e5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-477357820-1171762096=:12155"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-477357820-1171762096=:12155
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 18 Feb 2007, Trent Waddington wrote:

> Despite which, legal bullshit is best left for lawyers.. the *intent*
> of the GPL is that if you distribute *any* changes, extensions or
> plugins for a GPL work, you do so under the GPL.  The law may not
> allow for this to be enforced, but it shouldn't need to.. one should
> read the GPL as 100% enforceable and follow it without looking for
> "loop holes" as it is the stated desire of how the author of the code
> wants you to use his work.  Looking for loop holes, and worse yet,
> discussing those loop holes in a public place, is just insulting.

by this same logic the EULA's that various commercial vendors use are completely 
valid, and the e-mail sigs that make you liable for reading e-mail are also 
valid.

it doesn't matter what the intent is if it's not a legal thing to require.

in the case of the GPL the key is the border of being a drivitive work or not.

some people would like to interpret this so broadly as to make it impossible to 
run userspace code on a GPL OS, however everyone who is sane recognises that 
this is beyond the boundry.

in the case of kernel modules, this is very murky territory, and it's one that 
nobody has felt compelled (and confident enough in the outcome) to litigate.

I've heard many people express their opinion on what it takes to be a derivitive 
work, but very few lawyers

one of the few that I have seen is from IBM's lawyers in the SCO case

quote:
  Second, SCO's claim that Dynix/ptx is a "derivative work" within the meaning of SCO's definition is likewise unhelpful to its motion. As an initial matter, the assertion is untenable because it is based on a definition of "derivative works based on such SOFTWARE PRODUCT" that is unsupported and in dispute (as stated above). Moreover, SCO fails even to identify the versions and components of the SOFTWARE PRODUCT and Dynix/ptx to which SCO refers. It is impossible to determine whether one product is a derivative work of another product without specific reference to what is at issue. See Gates Rubber Co. v. Bando Chem. Indus., 9 F.3d 823, 834 (10th Cir. 1993) (indicating that, in determining whether one work is a derivative of another, a court should "dissect", "examine", and "compare" the two specific works in question).

To support the proposition that Dynix/ptx is a derivative work of UNIX System V, SCO relies entirely on the testimony of its experts, Mr. Marc Rochkind and Dr. Thomas Cargill. However, as SCO admits, Mr. Rochkind's testimony is based solely on a "computer-science perspective". (SCO Br. at 14.) There is no basis for importing into the Agreement the perspective of a single computer scientist offered two decades after the Agreement was signed and providing no objective standard for his testimony. 4 See Fed. R. Evid. 702 (requiring that expert testimony be "the product of reliable principles and methods"). The term "derivative work" is a term of art under copyright law and is explicitly defined in the Copyright Act as "a work that is based on (or derived from) one or more already existing works. . . in which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship". 17 U.S.C.A. § 101 (West 2006). In the absence of a provision in the Agreement to the contrary, the term "derivative work" should be understood to have the meaning that it has under federal law. One of IBM's experts, Professor Randall Davis, has provided unrebutted testimony that the portions of Dynix specifically challenged by SCO are not derivative works of UNIX System V. (Ex. 181 ¶50.)

this seems to be saying that the boundries of derivitive work as far as 
copyright goes are much more limited then just about anyone in computer science 
would define the term

David Lang
--8323328-477357820-1171762096=:12155--
