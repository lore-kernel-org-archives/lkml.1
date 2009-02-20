Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZBTDBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZBTDBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZBTDBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:01:05 -0500
Received: from web33503.mail.mud.yahoo.com ([68.142.206.152]:45693 "HELO
	web33503.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752797AbZBTDBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:01:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=SAfYPyB1P2/O0cJQcdVxbaTwybVjnFfVCSme4sA7Gw/Sd9nhyKhH5lv9sHqNZ1D3J1BeohEJSbclcgvX+i2rhZQtnYt58zLSoAD9flOHpLFbt5QxhO4+DysapkzxizBQUta+hd6arT1e6wPcsw2SymPcXC/g8zX59pp3R3V8D/0=;
X-YMail-OSG: MI23RLAVM1ncAJ3t406e._bh_TQoEi8n2Qezj0N0JZINtGqUngQYrzi.x1kXiZDnKmsiY5E.Hg.1jwpM5VeC7CNROakz7L2bNz4NsgHwtSLFC7PouyxQ8MkxWMpHxkpoD4Z7jRe.jst9Nt1zzhWeOlrn1Esspsop4SfmkDJsFiOFIlLf_EAUSISytZtO
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 18:54:23 -0800 (PST)
From: Nick Levinson <nick_levinson@yahoo.com>
Subject: suggest allowing listing CLI commands parallel to GUI menu programs
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <491130.39708.qm@web33503.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem: When I'm used to running a GUI desktop but I can't use the GUI to solve a problem involving a program and need to use a console, I'd like to know what console command would get me started with that program.

Proposal: That the kernel install with an empty or nearly-empty commentable text file with a publicized name and a format standard, the format to be stated in a comment and the file to be loose in one of the directories that is standard with most kernels and distros.

Then a GUI designer, such as one responsible for deciding what goes into a panel menu and what menu commands will be named, could write into that file the console equivalents of the menu commands for that GUI. A console equivalent could be the path and name of an executable associated with a given menu command, or could be a detailed ReadMe text file.

Entries in the file would be by GUI; for each GUI, each menu would be named; for each menu, each command would be named; for each command, the path and filename for the relevant executable (or more than one) would be listed; if typing the executable into a console would not be adequate because the console would need another name to gain access to the relevant capabilities, the relevant other name would be listed; comments could be written for any entry, such as if certain parameters are recommended.

The user with a problem would use a console to read the file and figure out what to do next.

This could have helped me one day when the screen was operating by one resolution but the panels didn't agree, and refused to display the Main Menu. I wanted to know what console command would give me access to the res. (I eventually solved the res problem another way.)

Thanks.

-- 
Nick


      
